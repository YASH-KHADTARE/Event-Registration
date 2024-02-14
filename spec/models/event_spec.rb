require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'Create Event' do

    it 'should be a valid event' do
      valid_event = build(:event)
      expect(valid_event.valid?).to eq(true)
    end

    it 'should be a invalid event' do
    invalid_event = build(:event, publish_date: '93 may 2024')
      expect(invalid_event.valid?).to eq(false)
      expect(invalid_event.errors[:publish_date]).to include("Enter date in valid format YYYY-MM-DD")
    end 

    it 'should have a title' do
      event = build(:event, title: nil)
      expect(event.valid?).to eq(false)
      expect(event.errors[:title]).to include("can't be blank")
    end

    it 'should have a venue' do
      event = build(:event, venue: nil)
      expect(event.valid?).to eq(false)
      expect(event.errors[:venue]).to include("can't be blank")
    end

    it 'should have a description' do
      event = build(:event, description: nil)
      expect(event.valid?).to eq(false)
      expect(event.errors[:description]).to include("can't be blank")
    end

  end
  
end
