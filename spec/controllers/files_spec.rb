require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:question) { create(:question, :with_files, files_count: 2) }
  let(:files) { question.attachments }
  before { sign_in question.user }

  describe 'DELETE #destroy' do
    it 'deletes files' do
      expect{files.each {|file| delete :destroy, id: file, format: :js}}.to change(Attachment, :count).by(-2)
    end

    it 'renders template destroy' do
      delete :destroy, id: files.first, format: :js
      expect(response).to render_template :destroy
    end
  end
end
