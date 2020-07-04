require "application_system_test_case"

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @profile = profiles(:one)
  end

  test "visiting the index" do
    visit profiles_url
    assert_selector "h1", text: "Profiles"
  end

  test "creating a Profile" do
    visit profiles_url
    click_on "New Profile"

    fill_in "Contributions", with: @profile.contributions
    fill_in "Email", with: @profile.email
    fill_in "Followers", with: @profile.followers
    fill_in "Following", with: @profile.following
    fill_in "Github url", with: @profile.github_url
    fill_in "Github username", with: @profile.github_username
    fill_in "Location", with: @profile.location
    fill_in "Name", with: @profile.name
    fill_in "Organization", with: @profile.organization
    fill_in "Profile image url", with: @profile.profile_image_url
    fill_in "Stars", with: @profile.stars
    click_on "Create Profile"

    assert_text "Profile was successfully created"
    click_on "Back"
  end

  test "updating a Profile" do
    visit profiles_url
    click_on "Edit", match: :first

    fill_in "Contributions", with: @profile.contributions
    fill_in "Email", with: @profile.email
    fill_in "Followers", with: @profile.followers
    fill_in "Following", with: @profile.following
    fill_in "Github url", with: @profile.github_url
    fill_in "Github username", with: @profile.github_username
    fill_in "Location", with: @profile.location
    fill_in "Name", with: @profile.name
    fill_in "Organization", with: @profile.organization
    fill_in "Profile image url", with: @profile.profile_image_url
    fill_in "Stars", with: @profile.stars
    click_on "Update Profile"

    assert_text "Profile was successfully updated"
    click_on "Back"
  end

  test "destroying a Profile" do
    visit profiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Profile was successfully destroyed"
  end
end