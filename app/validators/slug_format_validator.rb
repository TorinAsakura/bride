# encoding: utf-8
class SlugFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.slug_format')) unless value =~ /\A[\w-]+\z/i
  end
end
