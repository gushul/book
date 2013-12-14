## API
----

### Users
Registration

    curl -X POST "Accept: application/json" -H "Content-Type: application/json" -d '{"user":{"email":"test-user@mail.com","password":"secret12", "phone":"0123456789"}}' http://localhost:3000/api/users

Verification

    curl -X POST "Accept: application/json" -H "Content-Type: application/json" -d '{"user":{"email":"test-user@mail.com","password":"secret12","verify_code":"98206"}}' http://localhost:3000/api/verification

### Reservations
                          
Listing an User’s reservation (user's reservation history)

    curl -X POST -H "Content-Type: application/json" -d '{"user":{"email":"user1@mail.com","password":"secret12"}}' http://localhost:3000/api/reservations
    
Listing an Owner’s reservation

    curl -X POST "Accept: application/json" -H "Content-Type: application/json" -d '{"owner":{"email":"owner1@mail.com","password":"secret12"}}' http://localhost:3000/api/owner/reservations
      
Create reservation as User

    curl -X POST -H "Content-Type: application/json" -d '{"user":{"email":"user1@mail.com","password":"secret12"}, "reservation":{"restaurant_id":26, "date": "2013-11-26 18:00:00", "start_time": "2013-08-17 18:00:00", "end_time": "2013-08-17 18:30:00", "party_size":5, "active": "false"} }' http://localhost:3000/api/reservations/create

Create reservation as Owner

    curl -X POST -H "Content-Type: application/json" -d '{"owner":{"email":"owner1@mail.com","password":"secret12"}, "reservation":{"restaurant_id":26, "date": "2013-11-26 18:00:00", "start_time": "2013-08-17 18:00:00", "end_time": "2013-08-17 18:30:00", "party_size":5, "active": "false", "name":"ADOLF", "phone": "012", "email":"1111@eee.com"} }' http://localhost:3000/api/owner/reservations/create

Update reservation as User

    curl -X POST -H "Content-Type: application/json" -d '{"user":{"email":"user1@mail.com","password":"secret12"}, "reservation":{"id": 56, "restaurant_id":26, "date": "2013-11-26 20:00:00", "start_time": "2013-10-20 10:00:00", "end_time": "2013-10-20 12:00:00", "party_size":3, "active": "false"} }' http://localhost:3000/api/reservations/update

Update reservation as Owner

    curl -X POST -H "Content-Type: application/json" -d '{"owner":{"email":"owner1@mail.com","password":"secret12"}, "reservation":{"id": 58, "restaurant_id":26, "date": "2013-11-26 20:00:00", "start_time": "2013-10-20 10:00:00", "end_time": "2013-10-20 12:00:00", "party_size":3, "active": "false", "name":"ADOLF", "phone": "012", "email":"222@eee.com"} }' http://localhost:3000/api/owner/reservations/update

Show owner's booking

    curl -X POST -H "Content-Type: application/json" -d '{"owner":{"email":"owner1@mail.com","password":"secret12"}, "reservation":{"id": 48} }' http://localhost:3000/api/owner/reservation

Delete owner's booking

    curl -X POST -H "Content-Type: application/json" -d '{"owner":{"email":"owner1@mail.com","password":"secret12"}, "reservation":{"id": 48} }' http://localhost:3000/api/owner/reservations/delete

### Restaurants

Listing an index of restaurants

    curl -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:3000/api/restaurants

Show an individual restaurant 

    curl -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:3000/api/restaurants/1

### Inventories

Listing future inventories of owners restaurant
    
    curl -X POST "Accept: application/json" -H "Content-Type: application/json" -d '{"owner":{"email":"owner1@mail.com","password":"secret12"}}' http://localhost:3000/api/owner/inventories

### Rewards

Reward history

    curl -H "Accept: application/json" -H "Content-Type: application/json" -d '{"user":{"email":"user1@mail.com","password":"secret12"}}' http://localhost:3000/api/rewards


