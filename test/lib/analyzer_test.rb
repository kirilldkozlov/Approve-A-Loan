require 'test_helper'

class AnalyzerTest < ActiveSupport::TestCase
  test 'check that the decision tree hits the standard of >65% accuracy' do
    assert Analyzer.new.test(0.65)
  end
end
