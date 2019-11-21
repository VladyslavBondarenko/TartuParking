defmodule ParkingWeb.ParkingControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.ParkingManager
  alias Parking.UserManager
  alias Parking.ParkingManager.Parking

  @create_attrs %{location: "58.387746,26.696940", timelimit: 0, area: "58.38811045707349,26.697406020617336 58.38760994822571,26.696209755396694 58.387022263039675,26.69730409667477 58.387601512622474,26.698371615862698"}
  @create_attrs2 %{location: "58.379579,26.708482", timelimit: 0, area: "58.37976392189816,26.70835325396729 58.379589546902395,26.70809576190186 58.37939829591593,26.70855710185242 58.379592359409166,26.70881995833588"}
  @create_attrs3 %{location: "58.382548,26.709504", timelimit: 0, area: "58.38273009407792,26.70879321461109 58.3822857547534,26.709758809856453 58.38238137254904,26.709962657741585 58.38281446167178,26.708943418315926"}
  @nearest_by_path %{location: "58.378390,26.738600", timelimit: 0, area: "58.37843010866203,26.738337120747474 58.37807571936761,26.73843904469004 58.37845260944946,26.739291987156776"}
  @nearest_by_distance %{location: "58.375391,26.736067", timelimit: 0, area: "58.37555082370519,26.73658919121317 58.375221721192396,26.73431467796854 58.374642268281995,26.735285637631932 58.375221721192396, 26.736685750737706"}
  @update_attrs %{location: "58.375073,26.704905", timelimit: 0, area: "58.375187675534306,26.70429053980945 58.37475449277052,26.704848439284547 58.374968271941995,26.705663830825074 58.37539582639919,26.704880625792725"}
  @invalid_attrs %{location: nil}

  def fixture(:parking) do
    ParkingManager.create_parking(@create_attrs2)
    ParkingManager.create_parking(@create_attrs3)
    ParkingManager.create_parking(@nearest_by_path)
    ParkingManager.create_parking(@nearest_by_distance)
    {:ok, parking} = ParkingManager.create_parking(@create_attrs)
    parking
  end

  setup %{conn: conn} do
    {_, jwt, _} = UserManager.token_sign_in("ivan","123");
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all parkings", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :index))
      assert json_response(conn, 200)["parkings"] == []
    end
  end

  describe "create parking" do
    test "renders parking when data is valid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @create_attrs)
      assert %{"id" => id} = json_response(conn, 200)
      conn = get(conn, Routes.parking_path(conn, :show, id))
      assert %{
              "id" => id,
              "location" => "58.387746,26.696940",
              "timelimit" => 0
            } = json_response(conn, 200)
    end
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.parking_path(conn, :create), parking: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update parking" do
    setup [:create_parking]

    test "renders parking when data is valid", %{conn: conn, parking: %Parking{id: id}} do
      conn = put(conn, Routes.parking_path(conn, :update, id), parking: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.parking_path(conn, :show, id))

      assert %{
        "id" => id,
        "location" => "58.375073,26.704905",
        "timelimit" => 0
      } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, parking: parking} do
      conn = put(conn, Routes.parking_path(conn, :update, parking), parking: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete parking" do
    setup [:create_parking]

    test "deletes chosen parking", %{conn: conn, parking: parking} do
      conn = delete(conn, Routes.parking_path(conn, :delete, parking))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.parking_path(conn, :show, parking))
      end
    end
  end

  describe "find nearest parking" do
    setup [:create_parking]

    test "parking itself is the nearest parking to it's location", %{conn: conn, parking: parking} do
      conn = get(conn, Routes.parking_path(conn, :nearest), location: parking.location)
      assert %{
        "parkings" => [
          %{
            "location" => "58.387746,26.696940",
            "timelimit" => 0
          },
          %{
            "location" => "58.382548,26.709504",
            "timelimit" => 0
          },
          %{
            "location" => "58.379579,26.708482",
            "timelimit" => 0
          }
        ]
      } = json_response(conn, 200)
    end

    test "nearest with limit", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :nearest), location: "58.386668,26.697528", limit: "2")
      assert %{
        "parkings" => [
          %{
            "location" => "58.387746,26.696940",
            "timelimit" => 0
          },
          %{
            "location" => "58.382548,26.709504",
            "timelimit" => 0
          }
        ]
      } = json_response(conn, 200)
    end

    # neares parking should be found by the shortest car path to it, not by shortest geo-distance
    # in this test nearest by distance is closer, but path to it is longer, because this parking is on another riverside
    test "nearest by path, not by location", %{conn: conn} do
      conn = get(conn, Routes.parking_path(conn, :nearest), location: "58.375644,26.739925", limit: "1") # target location
      assert %{
        "parkings" => [
          %{
            "location" => "58.378390,26.738600",
            "timelimit" => 0
          }
        ]
      } = json_response(conn, 200)
    end
  end

  defp create_parking(_) do
    parking = fixture(:parking)
    {:ok, parking: parking}
  end


end
