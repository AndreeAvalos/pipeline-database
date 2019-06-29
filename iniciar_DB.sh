
#!/usr/bin/env bash
#docker run -d -p 3306:3306 --name my-mysql \
#-v ~/my-mysql/sql-scripts:/docker-entrypoint-initdb.d/ \

#-e MYSQL_ROOT_PASSWORD=123456789 \
#-e MYSQL_DATABASE=company \
#mysql

docker run --name database \
-e MYSQL_ROOT_PASSWORD=1234 \
-d database \
--character-set-server=utf8mb4 \
--collation-server=utf8mb4_unicode_ci \
--default-authentication-plugin=mysql_native_password

#--character-set-server=utf8mb4', '--collation-server=utf8mb4_unicode_ci','--default-authentication-plugin=mysql_native_password'
# docker run -d -p 3306:3306 --name my-mysql \
# -e MYSQL_ROOT_PASSWORD=supersecret my-mysql

# docker exec -it my-mysql bash
# https://medium.com/@lvthillo/customize-your-mysql-database-in-docker-723ffd59d8fb
