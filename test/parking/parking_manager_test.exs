defmodule Parking.ParkingManagerTest do
  use Parking.DataCase

  alias Parking.ParkingManager

  describe "parkings" do
    alias Parking.ParkingManager.Parking

    @valid_attrs %{location: "58.378609, 26.738889"}
    @update_attrs %{location: "58.378605, 26.739101"}
    @invalid_attrs %{location: nil}

    def parking_fixture(attrs \\ %{}) do
      {:ok, parking} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ParkingManager.create_parking()
      parking
    end

    test "list_parkings/0 returns all parkings" do
      parking = parking_fixture()
      assert ParkingManager.list_parkings() == [parking]
    end

    test "get_parking!/1 returns the parking with given id" do
      parking = parking_fixture()
      assert ParkingManager.get_parking!(parking.id) == parking
    end

    test "create_parking/1 with valid data creates a parking" do
      assert {:ok, %Parking{} = parking} = ParkingManager.create_parking(@valid_attrs)
      assert parking.location == "58.378609, 26.738889"
    end

    test "create_parking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ParkingManager.create_parking(@invalid_attrs)
    end

    test "update_parking/2 with valid data updates the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{} = parking} = ParkingManager.update_parking(parking, @update_attrs)
      assert parking.location == "58.378605, 26.739101"
    end

    test "update_parking/2 with invalid data returns error changeset" do
      parking = parking_fixture()
      assert {:error, %Ecto.Changeset{}} = ParkingManager.update_parking(parking, @invalid_attrs)
      assert parking == ParkingManager.get_parking!(parking.id)
    end

    test "delete_parking/1 deletes the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{}} = ParkingManager.delete_parking(parking)
      assert_raise Ecto.NoResultsError, fn -> ParkingManager.get_parking!(parking.id) end
    end

    test "change_parking/1 returns a parking changeset" do
      parking = parking_fixture()
      assert %Ecto.Changeset{} = ParkingManager.change_parking(parking)
    end
  end
end
