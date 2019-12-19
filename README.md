# TartuParking

Backend for parking application. Elixir/Phoenix + PostgreSQL

### Implemented features:

* Interactive search for parking space
	 * Get summary of available parking space around certain location
	 * Get space availability and information about the price that applies current street zone
* Parking payment
	 * Submit a start and end of parking time
 	* Identificate the parking space for sertain location
 	* Block the corresponding parking space and update the availability of such parking space (after a booking)
	 * Extend the parking period
* Bookings
 	* (On hourly-based payment) Pay before starting the parking period
	 * (On hourly-based payment) Pay when extending the parking period
	 * (On real-time payment) Pay at the end of the parking period
  * Get history of all bookings for current user
  * Get active booking for current user
* User profile
  * Authentication (users have access only to their information)
  * Update wallet of current user

### Installation

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser
