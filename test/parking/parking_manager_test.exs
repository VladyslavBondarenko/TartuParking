defmodule Parking.ParkingManagerTest do
  use Parking.DataCase

  alias Parking.ParkingManager

  describe "parkings" do
    alias Parking.Parking

    @valid_attrs %{location: "58.382548,26.709504", timelimit: 0, area: "58.38273009407792,26.70879321461109 58.3822857547534,26.709758809856453 58.38238137254904,26.709962657741585 58.38281446167178,26.708943418315926"}
    @update_attrs %{location: "58.375073,26.704905", timelimit: 0, area: "58.375187675534306,26.70429053980945 58.37475449277052,26.704848439284547 58.374968271941995,26.705663830825074 58.37539582639919,26.704880625792725"}
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
      assert parking.location == "58.382548,26.709504"
    end

    test "create_parking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ParkingManager.create_parking(@invalid_attrs)
    end

    test "update_parking/2 with valid data updates the parking" do
      parking = parking_fixture()
      assert {:ok, %Parking{} = parking} = ParkingManager.update_parking(parking, @update_attrs)
      assert parking.location == "58.375073,26.704905"
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
  end
end
