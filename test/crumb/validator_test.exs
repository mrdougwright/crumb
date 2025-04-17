defmodule Crumb.ValidatorTest do
  use Crumb.DataCase, async: true

  alias Crumb.Validator

  describe "validate/1" do
    test "valid event input returns {:ok, clean_params}" do
      params = %{
        "event" => "user_signup",
        "userId" => "abc123",
        "properties" => %{}
      }

      assert {:ok, clean_params} = Validator.validate(params)
      assert clean_params.event == "user_signup"
      assert clean_params.user_id == "abc123"
      assert is_map(clean_params.properties)
      assert Map.has_key?(clean_params, :inserted_at)
    end

    test "valid identify input returns {:ok, clean_params}" do
      params = %{
        "userId" => "abc123",
        "traits" => %{
          "email" => "test@example.com"
        }
      }

      assert {:ok, clean_params} = Validator.validate(params)
      assert %{"email" => _} = clean_params.traits
      assert clean_params.user_id == "abc123"
      assert Map.has_key?(clean_params, :inserted_at)
    end

    test "missing required fields returns {:error, changeset}" do
      params = %{
        "properties" => %{}
      }

      assert {:error, changeset} = Validator.validate(params)
      assert changeset.valid? == false
      assert ["can't be blank"] = errors_on(changeset).user_id
    end
  end
end
