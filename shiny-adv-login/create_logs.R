# create user_dat and user_his 
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
                                  "manager"),
                       
                       stringsAsFactors = FALSE
                       )

# create user_his
# this vector will record the number of login attempts
user_his <- vector(mode = "integer", length = nrow(user_dat))
names(user_his) <- unlist(user_dat$user)

# create empty user_log
user_log <- data.frame(username = c(),
                      timestamp = c())

# save files
saveRDS(user_dat, file = "shiny-adv-login/logs/user_dat.rds")
saveRDS(user_his , file = "shiny-adv-login/logs/user_his.rds")
saveRDS(user_log , file = "shiny-adv-login/logs/user_log.rds")
