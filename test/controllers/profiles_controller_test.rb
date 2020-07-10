require 'test_helper'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_url
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post profiles_url, params: { profile: { contributions: @profile.contributions, email: @profile.email, followers: @profile.followers, following: @profile.following, github_url: @profile.github_url, github_username: @profile.github_username, location: @profile.location, username: @profile.username, organization: @profile.organization, profile_image_url: @profile.profile_image_url, stars: @profile.stars } }
    end

    assert_redirected_to profile_url(Profile.last)
  end

  test "should show profile" do
    get profile_url(@profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile" do
    patch profile_url(@profile), params: { profile: { contributions: @profile.contributions, email: @profile.email, followers: @profile.followers, following: @profile.following, github_url: @profile.github_url, github_username: @profile.github_username, location: @profile.location, username: @profile.username, organization: @profile.organization, profile_image_url: @profile.profile_image_url, stars: @profile.stars } }
    assert_redirected_to profile_url(@profile)
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete profile_url(@profile)
    end

    assert_redirected_to profiles_url
  end

  test "should update informations and redirect to show page" do
    mock = Minitest::Mock.new
    def mock.get_github_info; true; end
    mock.expect :id, @profile.id

    Profile.stub :new, mock do
      post "/profiles/#{@profile.id}/update_informations", params: {}
    end
    
    assert_redirected_to profile_url(@profile)
  end

end
