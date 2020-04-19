require "rails_helper"

describe HomeController, type: :controller do
  describe "GET #index" do
    context "with no search param" do
      let(:empty_object) { OpenStruct.new(success: true, error_msg: "", items: []) }

      it "returns a success response" do
        allow(controller).to receive(:search).and_return(empty_object)
        get :index, params: {}
        expect(assigns(:result)).to eq empty_object
        expect(response).to be_successful
      end
    end

    context "with value for search param" do
      let(:error_object) { OpenStruct.new(success: false, error_msg: "some error msg", items: []) }
      let(:success_object) {
        OpenStruct.new(success: true, error_msg: "", items: [OpenStruct.new(
                         full_name: "test",
                         language: "Ruby",
                         url: "",
                         pushed_at: "",
                       )])
      }
      it "an error happen" do
        allow(controller).to receive(:search).and_return(error_object)
        get :index, params: { search: "anything" }
        expect(assigns(:result)).to eq error_object
        expect(response).to be_successful
      end

      it "returns a success response" do
        allow(controller).to receive(:search).and_return(success_object)
        get :index, params: { search: "anything" }
        expect(assigns(:result)).to eq success_object
        expect(response).to be_successful
      end
    end
  end
end
