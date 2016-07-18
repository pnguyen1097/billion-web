require 'rails_helper'

describe TransactionsController, type: :controller do
  describe 'GET new' do
    before { create :current_competition, dollar_to_point: 12 }

    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET create' do
    before { create :current_competition }

    let(:project) { create :project, competition: Competition.current_competition }
    let(:temp_user) { create :temp_user }
    let(:amount) { '$2,222.11' }

    let(:valid_params) do
      {
        transaction: {
          amount: amount,
          recipient_id: project.id,
          temp_user: {
            email: temp_user.email
          }
        },
        payment_method_nonce: 'thisisanonce'
      }
    end

    context 'successful' do
      before do
        expect(TransactionMailer).to receive(:confirmation).and_call_original
      end

      subject(:create_transaction) { post :create, valid_params }

      it { is_expected.to have_http_status(:created) }
      it { is_expected.to render_template(:create) }

      it 'create a transaction' do
        expect { create_transaction }.to change { Transaction.count }.by(2)
      end

      it 'rounds the transaction points up' do
        raw_points = 2222.11 * Competition.current_competition.dollar_to_point
        expected_points = raw_points.ceil

        create_transaction

        expect(Transaction.last.points).to eq(expected_points)
      end
    end

    context 'unsuccessful' do
      shared_examples 'it fails to create a transaction' do
        before do
          expect(TransactionMailer).to_not receive(:confirmation)
        end

        it { is_expected.to have_http_status(:ok) }
        it { is_expected.to render_template(:new) }

        it 'does not create a transaction' do
          expect { create_transaction }.to_not change { Transaction.count }
        end

        it 'assigns a transaction' do
          create_transaction
          expect(assigns(:transaction)).to be_present
        end

        it 'flashes an error' do
          create_transaction
          expect(flash[:error]).to be_present
        end
      end

      context 'with invalid payment' do
        subject(:create_transaction) do
          post :create, valid_params
        end

        before { FakeBraintree.decline_all_cards! }

        include_examples 'it fails to create a transaction'

        after { FakeBraintree.clear! }
      end

      context 'with invalid temp user' do
        subject(:create_transaction) do
          post :create, valid_params.tap { |p| p[:transaction].delete(:temp_user) }
        end

        include_examples 'it fails to create a transaction'
      end

      context 'with invalid purchase' do
        subject(:create_transaction) do
          post :create, valid_params.merge(transaction: { amount: 0 })
        end

        include_examples 'it fails to create a transaction'
      end

      context 'with invalid allocatons' do
        subject(:create_transaction) do
          post :create, valid_params.tap { |p| p[:transaction].delete(:recipient_id) }
        end

        include_examples 'it fails to create a transaction'
      end
    end
  end
end
