require 'rails_helper'

describe Competition, type: :model do
  # TODO: Add validations to ensure only 1 competition per time period
  describe 'validations' do
    it { should validate_presence_of(:code_name) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_numericality_of(:dollar_to_point).is_greater_than_or_equal_to(1) }
  end

  describe 'associations' do
    it do
      is_expected.to have_many(:projects)
        .inverse_of(:competition)
        .dependent(:destroy)
    end

    it do
      is_expected.to have_many(:transactions)
        .inverse_of(:competition)
        .dependent(:destroy)
    end

    it do
      is_expected.to have_many(:rounds)
        .inverse_of(:competition)
        .dependent(:destroy)
    end
  end

  describe '#total_raised' do
    it 'returns the total funds raise, excluding wine' do
      competition = create :competition, dollar_to_point: 1
      wine = create :project, competition: competition, wine: true
      projects = create_list :project, 5, competition: competition, wine: false

      create :transaction, recipient: wine, amount: 20
      projects.each do |project|
        create :transaction, sender: nil, recipient: project, competition: competition, points: 10
      end

      expect(competition.total_raised).to eq(projects.length * 10)
    end
  end

  describe '#active_round' do
    context 'with active round' do
      it 'returns the active round' do
        competition = create :competition
        active_round = create :active_round, competition: competition
        create :inactive_round, competition: competition

        expect(competition.active_round).to eq(active_round)
      end
    end

    context 'with no active round' do
      it 'returns nil' do
        competition = create :competition
        create :inactive_round, competition: competition

        expect(competition.active_round).to be_nil
      end
    end
  end

  describe '.current_competition' do
    context 'there is a current competition' do
      it 'returns the current competition' do
        create :previous_competition
        create :future_competition
        current_competition = create :current_competition

        expect(Competition.current_competition).to eq(current_competition)
      end
    end

    context 'there is no current competition' do
      it 'returns nil' do
        expect(Competition.current_competition).to be_nil
      end
    end
  end
end
