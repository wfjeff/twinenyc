require 'spec_helper'

describe UsersController do
  let(:tenant) { create(:user) }
  let(:lawyer) { create(:user, permissions: User::PERMISSIONS[:lawyer]) }
  let(:admin) { create(:user, permissions: User::PERMISSIONS[:admin]) }

  describe "GET /users/:id/download" do
    let(:pdf_writer) { double('pdf_writer') }
    let(:file) { double('file') }

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(PDFWriter).to receive(:new_from_user_id).with("1").and_return pdf_writer
      allow(pdf_writer).to receive(:generate_pdf).and_return file
      allow(pdf_writer).to receive(:filename)
      allow(pdf_writer).to receive(:content_type)
      allow(controller).to receive(:send_data).
                              with(file, filename: pdf_writer.filename, type: pdf_writer.content_type).
                              and_return{controller.render :nothing => true}
    end

    it "instantiates a pdf writer" do
      expect(PDFWriter).to receive(:new_from_user_id).with("1").and_return pdf_writer
      get :download_pdf, id: 1
    end

    it "sends the data" do
      expect(controller).to receive(:send_data).
                              with(file, filename: pdf_writer.filename, type: pdf_writer.content_type).
                              and_return{controller.render :nothing => true}
      get :download_pdf, id: 1                            
    end
  end

  describe "GET /users/:id/edit" do
    it "should render the edit view for an admin user" do
      sign_in admin
      get :edit, id: tenant

      expect(response.status).to eq(200)
      expect(response).to render_template("edit")
    end

    it "should redirect a non-admin user to the root path" do
      sign_in tenant
      get :edit, id: tenant

      expect(response).to redirect_to(root_path)

      sign_in lawyer
      get :edit, id: tenant

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET /users/:id/update" do
    let(:params) { { id: tenant, user: { first_name: "Updated" } } }

    it "should update the resource if the request comes from an admin user" do
      admin.collaborations.create(collaborator: tenant)
      sign_in admin
      put :update, params

      expect(response.status).to eq(302)
      expect(tenant.reload.first_name).to eq("Updated")
    end

    it "should redirect a request from a non-admin user" do
      sign_in tenant
      put :update, params

      expect(response).to redirect_to(root_path)

      sign_in lawyer
      put :update, params

      expect(response).to redirect_to(root_path)
    end
  end
end
