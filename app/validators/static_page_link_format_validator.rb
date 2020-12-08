# encoding: utf-8
class StaticPageLinkFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('activerecord.errors.static_page_link_format')) unless value =~ /\A[-\/\w]+\z/i
  end
end
