# encoding: utf-8
module Admin::TasksHelper

  def to_mb byte
    "#{'%.2f' % (byte.to_f / 2**20)} mb"
  end
end