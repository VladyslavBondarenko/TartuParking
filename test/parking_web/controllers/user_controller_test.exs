defmodule ParkingWeb.UserControllerTest do
  use ParkingWeb.ConnCase

  alias Parking.UserManager
  alias Parking.User

  @create_attrs %{
    full_name: "some username",
    username: "some username",
    password: "some password"
  }
  @update_attrs %{
    full_name: "some updated username",
    username: "some updated username",
    password: "some updated password"
  }
  @invalid_attrs %{password: nil, username: nil}

  @booking_hourly_attrs %{
    startDateTime: "2019-11-21T12:52:29.360Z",
    endDateTime: "2019-11-21T22:52:29.360Z",
    location: "58.379990,26.719745",
    type: "hourly"
  }
  @booking_realtime_start_attrs %{
    startDateTime: "2019-11-21T12:52:29.360Z",
    location: "58.379990,26.719745",
    type: "realtime"
  }
  @booking_realtime_end_attrs %{
    endDateTime: "2019-11-21T22:52:29.360Z",
  }

  def fixture(:user) do
    {:ok, user} = UserManager.create_user(@create_attrs)
    user
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
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert [%{"full_name" => "", "id" => 1, "username" => "ivan", "money" => 0.0}] = json_response(conn, 200)["users"]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"full_name" => "some username", "username" => "some username"} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id}} do
      conn = put(conn, Routes.user_path(conn, :update, id), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)
      conn = get(conn, Routes.user_path(conn, :show, id))
      assert %{"full_name" => "some updated username", "id" => id, "username" => "some updated username"} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  describe "update user money" do
    setup [:create_user]

    test "increase value", %{conn: conn, user: user} do
      assert user.money == 0.0
      conn = put(conn, Routes.user_path(conn, :updateMoney, user.id), value: 100)
      assert %{"money" => 100.0} = json_response(conn, 200)
      user = UserManager.get_user!(user.id)
      assert user.money == 100.0
    end

    test "decrease value", %{conn: conn, user: user} do
      assert user.money == 0.0
      conn = put(conn, Routes.user_path(conn, :updateMoney, user.id), value: -5.5)
      assert %{"money" => -5.5} = json_response(conn, 200)
      user = UserManager.get_user!(user.id)
      assert user.money == -5.5
    end

    test "decreased after creating hourly booking", %{conn: conn, user: user} do
      assert user.money == 0.0
      conn = post(conn, Routes.booking_path(conn, :create), booking: @booking_hourly_attrs)
      assert %{"cost" => 20.0} = json_response(conn, 200)
      user = UserManager.get_user!(conn.private.guardian_default_resource.id)
      assert user.money == -20.0
    end

    test "decreased after end realtime booking", %{conn: conn, user: user} do
      assert user.money == 0.0
      conn = post(conn, Routes.booking_path(conn, :create), booking: @booking_realtime_start_attrs)
      booking_id = json_response(conn, 200)["id"]
      assert %{"cost" => nil} = json_response(conn, 200)
      assert UserManager.get_user!(conn.private.guardian_default_resource.id).money == 0.0
      conn = put(conn, Routes.booking_path(conn, :update, booking_id), booking: @booking_realtime_end_attrs)
      assert %{"cost" => 19.2} = json_response(conn, 200)
      assert UserManager.get_user!(conn.private.guardian_default_resource.id).money == -19.2
    end

  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
