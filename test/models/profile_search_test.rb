require 'test_helper'

class ProfileSearchTest < ActiveSupport::TestCase
    setup do
        create_profiles
    end
  
    # tests for searchs by username

    test "find profile by username" do
      results = Profile.username(profiles(:two).username)
      assert results.size == 1
      assert results.first.username == profiles(:two).username
    end
  
    test "find profile by username with capitalization" do
      results = Profile.username(profiles(:two).username.upcase)
      assert results.size == 1
      assert results.first.username == profiles(:two).username 
    end
  
    test "find profile by part of the username" do
      results = Profile.username("ma")
      assert results.size == 1
      assert results.first.username == profiles(:two).username 
    end
  
    test "find multiple profiles by username" do
      results = Profile.username("")
      assert results.size == 2
    end

    # tests for searchs by github username

    test "find profile by github_username" do
        results = Profile.github_username(profiles(:two).github_username)
        assert results.size == 1
        assert results.first.github_username = profiles(:two).github_username
    end

    test "find profile by github_username with capitalization" do
        results = Profile.github_username(profiles(:two).github_username.upcase)
        assert results.size == 1
        assert results.first.github_username == profiles(:two).github_username
    end

    test "find profile by part of the github_username" do
        results = Profile.github_username("mat")
        assert results.size == 1
        assert results.first.github_username == profiles(:two).github_username
    end

    test "find multiple profiles by github_username" do
        results = Profile.github_username("")
        assert results.size == 2
    end


    # tests for searchs by location

     test "find profile by location" do
        results = Profile.location(profiles(:two).location)
        assert results.size == 1
        assert results.first.location = profiles(:two).location
    end

    test "find profile by location with capitalization" do
        results = Profile.location(profiles(:two).location.upcase)
        assert results.size == 1
        assert results.first.location == profiles(:two).location
    end

    test "find profile by part of the location" do
        results = Profile.location("Japan")
        assert results.size == 1
        assert results.first.location == profiles(:two).location
    end

    test "find multiple profiles by location" do
        results = Profile.location("")
        assert results.size == 2
    end
  

    # tests for searchs by organization

    test "find profile by organization" do
        results = Profile.organization(profiles(:two).organization)
        assert results.size == 1
        assert results.first.organization = profiles(:two).organization
    end

    test "find profile by organization with capitalization" do
        results = Profile.organization(profiles(:two).organization.upcase)
        assert results.size == 1
        assert results.first.organization == profiles(:two).organization
    end

    test "find profile by part of the organization" do
        results = Profile.organization("Ruby")
        assert results.size == 1
        assert results.first.organization == profiles(:two).organization
    end

    test "find multiple profiles by organization" do
        results = Profile.organization("")
        assert results.size == 2
    end
  end