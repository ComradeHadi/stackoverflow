require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question, :with_files, files_count: 1) }
  let(:files) { question.attachments }
  let(:user) { create(:user) }
  let(:delete_file) { delete :destroy, id: files.first, format: :js }

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      before { sign_in question.author }

      it 'deletes files' do
        expect { delete_file }.to change { Attachment.count }.by(-1)
      end

      it 'renders template destroy' do
        delete_file
        expect(response).to render_template :destroy
      end
    end

    context 'with invalid attributes' do
      before { sign_in user }

      it 'does not delete files' do
        expect { delete_file }.to_not change { Attachment.count }
      end

      it 'renders status 403 forbidden' do
        delete_file
        expect(response).to be_forbidden
      end
    end
  end
end
