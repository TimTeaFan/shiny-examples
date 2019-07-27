# create user_dat, user_his and user_log
library("bcrypt")


# use hashed passwords with for example the bcrypt package
# this should not be part of a script that is saved on your server

# hashing example:
# passwd <- "bosslogin" # never use passwords in clear text in your script
# hashpw(passwd)
# use hash

# create user_dat with hashed passwords
user_dat <- data.frame(user = c("worker",
                                "boss"),
                       
                       pass = c("$2a$12$2AkZzyczezDbdeGD0gCeFu8MfqUu1iAM2nNJc6u2VS2azihogRsIa",
                                "$2a$12$/qQoLFAPJoA.UgdVN8iYZOKrVW1e37xpDYtyc2/IUq36hNiSS5cnK"),
                       
                       access = c("user",
                                  "manager")
                       )

# create user_his
# this vector will record the number of login attempts
user_his <- vector(mode = "integer", length = length(user_dat))
names(user_his) <- names(user_dat$user)

# create user_log
# 