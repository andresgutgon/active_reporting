require 'test_helper'

class ActiveReporting::DimensionTest < ActiveSupport::TestCase
  def test_dimension_can_have_a_type
    subject = ActiveReporting::Dimension.new(PostFactModel, name: :creator)
    assert_equal :standard, subject.type

    subject = ActiveReporting::Dimension.new(PostFactModel, name: :state)
    assert_equal :degenerate, subject.type

    assert_raises ActiveReporting::UnknownDimension do
      ActiveReporting::Dimension.new(PostFactModel, name: :not_a_dimension).type
    end
  end
end
