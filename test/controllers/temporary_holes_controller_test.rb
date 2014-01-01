require 'test_helper'

class TemporaryHolesControllerTest < ActionController::TestCase
  setup do
    @temporary_hole = temporary_holes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:temporary_holes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create temporary_hole" do
    assert_difference('TemporaryHole.count') do
      post :create, temporary_hole: { end_port: @temporary_hole.end_port, end_time: @temporary_hole.end_time, instance_id: @temporary_hole.instance_id, ip_address: @temporary_hole.ip_address, sg_id: @temporary_hole.sg_id, start_port: @temporary_hole.start_port, user_id: @temporary_hole.user_id }
    end

    assert_redirected_to temporary_hole_path(assigns(:temporary_hole))
  end

  test "should show temporary_hole" do
    get :show, id: @temporary_hole
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @temporary_hole
    assert_response :success
  end

  test "should update temporary_hole" do
    patch :update, id: @temporary_hole, temporary_hole: { end_port: @temporary_hole.end_port, end_time: @temporary_hole.end_time, instance_id: @temporary_hole.instance_id, ip_address: @temporary_hole.ip_address, sg_id: @temporary_hole.sg_id, start_port: @temporary_hole.start_port, user_id: @temporary_hole.user_id }
    assert_redirected_to temporary_hole_path(assigns(:temporary_hole))
  end

  test "should destroy temporary_hole" do
    assert_difference('TemporaryHole.count', -1) do
      delete :destroy, id: @temporary_hole
    end

    assert_redirected_to temporary_holes_path
  end
end
