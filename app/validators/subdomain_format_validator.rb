# encoding: utf-8
class SubdomainFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.subdomain_format')) unless value =~ /\A[\w-]+\z/i
  end
end
