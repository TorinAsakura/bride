namespace :cities do
  desc "Download and load into database fresh cities data from ipgeobase.ru. Requires unzip, psql, iconv"
  task :cold => :environment do
    with_fresh_update do |cities_filename, ip_ranges_filename|
      begin
        drop_tmp_tables
        create_tmp_tables
        load_raw_data(cities_filename, ip_ranges_filename)
        process_cold_data
      ensure
        drop_tmp_tables
      end
    end
  end


  task :update => :environment do
    with_fresh_update do |cities_filename, ip_ranges_filename|
      begin
        drop_tmp_tables
        create_tmp_tables
        load_raw_data(cities_filename, ip_ranges_filename)
        update_data
      ensure
        drop_tmp_tables
      end
    end
  end

  def with_fresh_update(&block)
    output_filename = Rails.root.join('tmp', 'geo_files.zip')
    cities_filename = Rails.root.join('tmp', 'cities.txt')
    ip_ranges_filename = Rails.root.join('tmp', 'cidr_optim.txt')
    begin
      command = "wget -O #{output_filename} http://ipgeobase.ru/files/db/Main/geo_files.zip"
      puts "Download file (#{command})" if trace?
      `#{command}`
      raise "Error on download updates from ipgeobase.ru" unless $?.success?
      command = "unzip -o #{output_filename} -d #{Rails.root.join('tmp')}"
      puts "Unzip files (#{command})" if trace?
      `#{command}`
      raise "Error on extracting files" unless $?.success?
      command = "iconv -f cp1251 -t utf8 -o #{cities_filename}.utf8 #{cities_filename} && mv -f #{cities_filename}.utf8 #{cities_filename}"
      puts "Convert cities.txt encoding (#{command})" if trace?
      `#{command}`
      raise "Unable to convert cities.txt encoing" unless $?.success?
      yield(cities_filename, ip_ranges_filename)
    rescue => e
      puts e.message if trace?
      Rails.logger.error "[Rake::cities::update] #{e.message}. #{e.backtrace.join("\n")}"
    ensure
      `rm -rf #{output_filename} #{cities_filename} #{ip_ranges_filename}`
    end
  end

  def drop_tmp_tables
    puts "Drop TMP tables"
    City.connection.execute("DROP TABLE IF EXISTS tmp_ip_geo_cities");
    City.connection.execute("DROP TABLE IF EXISTS tmp_ip_geo_ranges");
  end

  def create_tmp_tables
    puts "Create TMP tables" if trace?
    sql = <<-SQL
      CREATE TABLE tmp_ip_geo_cities (
        id INT,
        name VARCHAR(100),
        region VARCHAR(100),
        area VARCHAR(100),
        latitude FLOAT,
        longitude FLOAT
      );
      CREATE TABLE tmp_ip_geo_ranges (
        range_start bigint,
        range_end   bigint,
        ip_range    varchar(33),
        country_code varchar(2),
        city_id     varchar(16)
      );
    SQL
    City.connection.execute(sql)
  end

  def pg_env
    db_config = Rails.configuration.database_configuration
    {
        'PGHOST' => db_config[Rails.env]["host"],
        'PGPORT' => db_config[Rails.env]["port"],
        'PGUSER' => db_config[Rails.env]["username"],
        'PGPASSWORD' => db_config[Rails.env]["password"],
        'PGDATABASE' => db_config[Rails.env]["database"]
    }
  end

  def pg_env_string
    pg_env.map { |k,v| "#{k}=#{v}"}.join(" ")
  end

  def load_raw_data(cities_filename, ip_ranges_filename)
    puts "Load data from csv" if trace?
    {
        "tmp_ip_geo_cities" => cities_filename,
        "tmp_ip_geo_ranges" => ip_ranges_filename
    }.each_pair do |table_name, file_name|
      sql = "copy #{table_name} FROM stdin DELIMITER E'\\t' CSV"
      command = "#{pg_env_string} psql -c \"#{sql}\" < #{file_name}"
      puts "#{command}" if trace?
      `#{command}`
      raise "Unable to load tmp_ip_geo_cities" unless $?.success?
    end
  end

  def process_cold_data(override = true)
    puts "Processing raw data" if trace?
    cast_city_id_to_int
    if override
      City.delete_all
      Region.delete_all
    end
    puts "Insert data into regions" if trace?
    sql = <<-SQL
      INSERT INTO regions (name, country_id) (
        SELECT tmp_ip_geo_cities.region, MAX(countries.id)
        FROM tmp_ip_geo_cities INNER JOIN tmp_ip_geo_ranges ON tmp_ip_geo_cities.id = tmp_ip_geo_ranges.city_id
            INNER JOIN countries ON countries.code = UPPER(tmp_ip_geo_ranges.country_code)
        GROUP BY tmp_ip_geo_cities.region

      );
    SQL
    City.connection.execute(sql)

    puts "Insert data into cities" if trace?
    sql = <<-SQL
      INSERT INTO cities (geoip_id, name, region_id, latitude, longitude, country_id) (
        SELECT DISTINCT tmp_ip_geo_cities.id, tmp_ip_geo_cities.name, regions.id, tmp_ip_geo_cities.latitude, tmp_ip_geo_cities.longitude, countries.country_id
        FROM tmp_ip_geo_cities INNER JOIN tmp_ip_geo_ranges ON tmp_ip_geo_cities.id = tmp_ip_geo_ranges.city_id
            INNER JOIN countries ON countries.code = UPPER(tmp_ip_geo_ranges.country_code)
            INNER JOIN regions ON countries.id = regions.country_id AND regions.name = tmp_ip_geo_cities.region
      );
    SQL
    City.connection.execute(sql)

    insert_ip_ranges

  end

  def cast_city_id_to_int
    City.connection.execute("ALTER TABLE tmp_ip_geo_ranges ALTER COLUMN city_id SET DATA TYPE INT USING CASE WHEN city_id = '-' THEN NULL ELSE city_id::integer END;")
  end

  def insert_ip_ranges
    puts "Insert data into ip_ranges" if trace?
    sql = "DELETE FROM ip_ranges";
    City.connection.execute(sql)

    sql = <<-SQL

      INSERT INTO ip_ranges (range_start, range_end, range, city_id, country_id) (
        SELECT tmp_ip_geo_ranges.range_start, tmp_ip_geo_ranges.range_end, tmp_ip_geo_ranges.ip_range, cities.id, countries.id
        FROM tmp_ip_geo_ranges INNER JOIN cities ON cities.id = tmp_ip_geo_ranges.city_id
            INNER JOIN countries ON countries.code = UPPER(tmp_ip_geo_ranges.country_code)
      );
    SQL

    City.connection.execute(sql)
  end

  def update_data
    cast_city_id_to_int
    puts "Insert data into regions" if trace?
    sql = <<-SQL
      INSERT INTO regions (name, country_id) (
        SELECT tmp_ip_geo_cities.region, MAX(countries.id)
        FROM tmp_ip_geo_cities INNER JOIN tmp_ip_geo_ranges ON tmp_ip_geo_cities.id = tmp_ip_geo_ranges.city_id
            INNER JOIN countries ON countries.code = UPPER(tmp_ip_geo_ranges.country_code)
            LEFT JOIN regions ON tmp_ip_geo_cities.region = regions.name AND countries.id = regions.country_id
        WHERE regions.id IS NULL
        GROUP BY tmp_ip_geo_cities.region

      );
    SQL
    City.connection.execute(sql)

    puts "Insert data into cities" if trace?
    sql = <<-SQL
      INSERT INTO cities (geoip_id, name, region_id, latitude, longitude, country_id) (
        SELECT DISTINCT tmp_ip_geo_cities.id, tmp_ip_geo_cities.name, regions.id, tmp_ip_geo_cities.latitude, tmp_ip_geo_cities.longitude, countries.country_id
        FROM tmp_ip_geo_cities INNER JOIN tmp_ip_geo_ranges ON tmp_ip_geo_cities.id = tmp_ip_geo_ranges.city_id
            INNER JOIN countries ON countries.code = UPPER(tmp_ip_geo_ranges.country_code)
            INNER JOIN regions ON countries.id = regions.country_id AND regions.name = tmp_ip_geo_cities.region
            LEFT JOIN cities ON tmp_ip_geo_cities.id = cities.geoip_id OR (cities.name = tmp_ip_geo_cities.name AND cities.region_id = regions.id)
        WHERE cities.id IS NULL
      );
    SQL
    City.connection.execute(sql)

    sql = <<-SQL
      UPDATE cities SET geoip_id = tmp_ip_geo_cities.id, latitude = tmp_ip_geo_cities.latitude, longitude = tmp_ip_geo_cities.longitude
      FROM tmp_ip_geo_cities INNER JOIN tmp_ip_geo_ranges ON tmp_ip_geo_cities.id = tmp_ip_geo_ranges.city_id
            INNER JOIN countries ON countries.code = UPPER(tmp_ip_geo_ranges.country_code)
            INNER JOIN regions ON countries.id = regions.country_id AND regions.name = tmp_ip_geo_cities.region
        WHERE cities.geoip_id IS NULL AND cities.name = tmp_ip_geo_cities.name AND cities.region_id = regions.id
    SQL
    City.connection.execute(sql)

    insert_ip_ranges

  end

  def trace?
    Rake.application.options.trace == true
  end

end
