require 'test_helper'

class InventoryTemplatesControllerTest < ActionController::TestCase
  setup do
    @inventory_template = inventory_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inventory_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inventory_template" do
    assert_difference('InventoryTemplate.count') do
      post :create, inventory_template: { end_time: @inventory_template.end_time, name: @inventory_template.name, primary: @inventory_template.primary, quantity_available: @inventory_template.quantity_available, start_time: @inventory_template.start_time }
    end

    assert_redirected_to inventory_template_path(assigns(:inventory_template))
  end

  test "should show inventory_template" do
    get :show, id: @inventory_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inventory_template
    assert_response :success
  end

  test "should update inventory_template" do
    put :update, id: @inventory_template, inventory_template: { end_time: @inventory_template.end_time, name: @inventory_template.name, primary: @inventory_template.primary, quantity_available: @inventory_template.quantity_available, start_time: @inventory_template.start_time }
    assert_redirected_to inventory_template_path(assigns(:inventory_template))
  end

  test "should destroy inventory_template" do
    assert_difference('InventoryTemplate.count', -1) do
      delete :destroy, id: @inventory_template
    end

    assert_redirected_to inventory_templates_path
  end
end
