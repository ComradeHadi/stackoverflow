require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:question) { create(:question_with_attachment) }
  let(:file) { question.attachments.first }
  before { sign_in question.user }

  describe 'DELETE #destroy' do
    it 'deletes file' do
      expect{ delete :destroy, id: file, format: :js }.to change(Attachment, :count).by(-1)
    end

    it 'renders template destroy' do
      delete :destroy, id: file, format: :js
      expect(response).to render_template :destroy
    end
  end
end
