# go-pg-gqlgen

Functionalities

- Automatically Create GraphQL schema for the underlying Database
- ORM Representation of the Database, to be used in Middleware GO
- GraphQL Playground to Create Cloud Resources and Store information in PG Database

Tables 

| Table Name    | GQL Read Write Enabled| Public Cloud Resource Creation Enabled |
| ------------- | -------------- |-----------------------------------------------
| domains  | Yes   |        | 
| classes  | Yes   |     |
| stages  | Yes   |     |
| privileges  | Yes   |     |
| tasks  | Yes   |     |
| roles  | Yes   |     |
| notifications  | Yes   |     |
| budgets  | Yes   |     |
| alerts  | Yes   |     |
| channels  | Yes   |     |
| subscriptions/agreements  | Yes   |     |
| sizes  | Yes   |     |
| **backups**  | Yes   |     |
| **dbs**  | Yes   |     |
| **buckets**  | Yes   | **Yes**    |
| **filesystems**  | Yes   |     |
| **residents**  | Yes   |     |
| **vpcs**  | Yes   |**Yes**     |
| **internetgateways**  | Yes   |**Yes**     |
| **subnets**  | Yes   |**Yes**     |
| **route_tables**  | Yes   |**Yes**     |
| **routes**  | Yes   |**Yes**     |
| **Security Group**  | Yes   |**Yes**     |
| **Network Intarface**  | Yes   |**Yes**     |
| **Elastic IP**  | Yes   |**Yes**     |
| **Instances**  | Yes   |**Yes**     |


Working Flow
1. Create vpc: DONE
2. Create Internet Gateway: DONE
3. Create Custom Route Table: DONE
4. Create Subnet: DONE
5. Associate Subnet with Route Table: DONE
6. Create Security Group to allow port 22, 80, 443: DONE
7. Create Network Interface with the ip in the subnet that was created in step 4 DONE
8. Assign an elastic IP to he network interface created in step 7 DONE
9. Create Ubuntu server DONE
10. Install/enable apache2 DONE


How to run

1. Clone the repository
2. RUN > GO111MODULE=on
3. RUN > go run ./server.go  

Output in console
> 2023/01/31 12:11:02 connect to http://localhost:8080/ for GraphQL playground

Open in Browser

> http://localhost:8080/

Sample Queries to run: https://github.com/paihari/go-pg-gqlgen/blob/main/samplequeries.txt

Next Step:
> Dockerize
























