# encoding : utf-8

MoneyRails.configure do |config|

  # To set the default currency
  #
  # config.default_currency = :usd

  # Set default bank object
  #
  # Example:
  # config.default_bank = EuCentralBank.new

  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  #
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115

  # To handle the inclusion of validations for monetized fields
  # The default value is true
  #
  #config.include_validations = true

  # Default ActiveRecord migration configuration values for columns:
  #
  # config.amount_column = { prefix: '',           # column name prefix
  #                          postfix: '_cents',    # column name  postfix
  #                          column_name: nil,     # full column name (overrides prefix, postfix and accessor name)
  #                          type: :integer,       # column type
  #                          present: true,        # column will be created
  #                          null: false,          # other options will be treated as column options
  #                          default: 0
  #                        }
  #
  # config.currency_column = { prefix: '',
  #                            postfix: '_currency',
  #                            column_name: nil,
  #                            type: :string,
  #                            present: true,
  #                            null: false,
  #                            default: 'USD'
  #                          }

  # Register a custom currency
  #
  # Example:
  config.register_currency = {
      priority:            1,
      iso_code:            "SVR",
      name:                "Svadba Ruble",
      symbol:              "SVR",
      symbol_first:        false,
      subunit_to_unit:     1,
      html_entity:         "<i class='icon-rouble'></i>",
      thousands_separator: " ",
      decimal_mark:        ","
  }

  config.add_rate "RUB", "SVR", 1

  config.default_currency = :svr

  # Set money formatted output globally.
  # Default value is nil meaning "ignore this option".
  # Options are nil, true, false.
  #
  # config.no_cents_if_whole = nil
  # config.symbol = nil
end

class Money
  module NiceAmount
    def to_nice
      c = self.currency
      dec = self.to_f % 100
      nice = if dec <= 40
               0
             elsif dec >= 60
               100
             else
               50
             end
      self + Money.new(nice - dec, c)
    end
  end
end
Money.send(:include, Money::NiceAmount)