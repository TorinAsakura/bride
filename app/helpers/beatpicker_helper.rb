# encoding: utf-8
module BeatpickerHelper
  def beatpicker(optionVar = nil)
    {
        beatpicker: true,
        'beatpicker-position' => "['*','*']",
        'beatpicker-extra'    => optionVar || "customBeatpickerOptions"
    }
  end
end
