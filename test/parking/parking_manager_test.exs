defmodule Parking.ParkingManagerTest do
  use Parking.DataCase

  alias Parking.{ParkingManager, Zone}

  describe "parkings" do
    alias Parking.Parking

    @valid_attrs %{location: "58.382548,26.709504", timelimit: 0, zone_id: 4, area: "58.38273009407792,26.70879321461109 58.3822857547534,26.709758809856453 58.38238137254904,26.709962657741585 58.38281446167178,26.708943418315926"}
    @update_attrs %{location: "58.375073,26.704905", timelimit: 0, zone_id: 4, area: "58.375187675534306,26.70429053980945 58.37475449277052,26.704848439284547 58.374968271941995,26.705663830825074 58.37539582639919,26.704880625792725"}
    @invalid_attrs %{location: nil}

    def parking_fixture() do
      ParkingManager.get_parking!(1)
    end

    test "list_parkings/0 returns all parkings" do
      assert [
        %Parking{
          area: "58.38811045707349,26.697406020617336 58.38760994822571,26.696209755396694 58.387022263039675,26.69730409667477 58.387601512622474,26.698371615862698",
          capacity: 20,
          location: "58.387746,26.696940",
          timelimit: 0,
          zone: %Zone{
            freeFirstMinutes: 0,
            hourPayment: 0.0,
            name: "free",
            realTimePayment: 0.0,
          }
        },
        %Parking{
          area: "58.37976392189816,26.70835325396729 58.379589546902395,26.70809576190186 58.37939829591593,26.70855710185242 58.379592359409166,26.70881995833588",
          capacity: 20,
          location: "58.379579,26.708482",
          timelimit: 0,
          zone: %Zone{
            freeFirstMinutes: 0,
            hourPayment: 0.0,
            name: "free",
            realTimePayment: 0.0,
          }
        },
        %Parking{
          area: "58.38273009407792,26.70879321461109 58.3822857547534,26.709758809856453 58.38238137254904,26.709962657741585 58.38281446167178,26.708943418315926",
          capacity: 20,
          location: "58.382548,26.709504",
          timelimit: 0,
          zone: %Zone{
            freeFirstMinutes: 0,
            hourPayment: 0.0,
            name: "free",
            realTimePayment: 0.0,
          }
        },
        %Parking{
          area: "58.37843010866203,26.738337120747474 58.37807571936761,26.73843904469004 58.37845260944946,26.739291987156776",
          capacity: 20,
          location: "58.378390,26.738600",
          timelimit: 0,
          zone: %Zone{
            freeFirstMinutes: 0,
            hourPayment: 0.0,
            name: "free",
            realTimePayment: 0.0,
          }
        },
        %Parking{
          area: "58.37555082370519,26.73658919121317 58.375221721192396,26.73431467796854 58.374642268281995,26.735285637631932 58.375221721192396,26.736685750737706",
          capacity: 20,
          location: "58.375391,26.736067",
          timelimit: 0,
          zone: %Zone{
            freeFirstMinutes: 0,
            hourPayment: 0.0,
            name: "free",
            realTimePayment: 0.0,
          }
        }
      ] = ParkingManager.list_parkings()
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
