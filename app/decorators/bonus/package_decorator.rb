class Bonus::PackageDecorator < Draper::Decorator
  delegate_all

  def duration
    months_count = object.months_count
    count = months_count.eql?(12) ? 1 : object.months_count
    misc = months_count.eql?(12) ? 'years' : 'months'
    "на #{I18n.t("misc.#{misc}", count: count)} "
  end
end