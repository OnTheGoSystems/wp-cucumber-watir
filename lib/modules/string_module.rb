# Some helpers for string handling
module StringModule
  def random_word
    (0...8).map { (65 + rand(26)).chr }.join
  end

  def file_name_base(scenario)
    scenario.name.split.join('_')
  end
end
