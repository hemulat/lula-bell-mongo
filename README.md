# Lula Bell's Resource Center

Rails app for Lula Bell's Resource Center

## Getting started

To get started with the app, clone the repo and then install the needed gems:
```
$ bundle update && bundle install
```

This app uses MongoDB so install MongoDB
```
https://docs.mongodb.com/manual/installation/
```
### Required
To get the app running you need to do a few one time operations.
* Open rails console
```
$ rails c
```
* Load script
```
load 'app/script/seed.rb'
```

* Seed Counter - This is needed for generating SKU naming of items
```
seed_counter
```

* Seed Super Admin - Only Super Admin can do certain things. This creates the first dummy super admin
```
seed_super_admin
```
### Optional
If you want you can create a dummy database for testing.
* Open rails console
```
rails c
```
* Load script
```
load 'app/script/populateDB.rb'
```
* Run the script (for fine  tuned options look at the script)
```
g_all
```
* Attach default image (currently 'apple.jpg' - 'app/assets/images/apple.jpg' )
```
attach_images
```

Finally start app in the local server

```
$ rails s
```

### Notes
* If you have an already existing database, you might want to query all items and re-save all items.
