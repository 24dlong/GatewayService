# GatewayService
The GatewayService repository is a proof of concept .NET GraphQL service. Together with the following repositories, it's meant to demonstrate how a Gateway Service can be used along with GraphQL Federation to create a single GraphQL API from
multiple GraphQL microservices:
- [UserService](https://github.com/24dlong/UserService)
- [ParkService](https://github.com/24dlong/ParkService)
- [HikeService](https://github.com/24dlong/HikeService)

The GatewayService provides a federated GraphQL API that brings together all the subgraphs in each of the 
microservices above into a single graph. Additionally, it demonstrates that subgraphs can be augmented with
foreign entities (like in the example below) that are beyond the scope of the original domain service.

## Prerequisites
Since this is a proof-of-concept, the images for the domain services do not exist in our docker repository.
Before running the GatewayService, you'll need to
1. Clone each of the domain services above
1. Run `make build` to build the docker image for each of the services to ensure that the images exist locally

To fully grasp the significance and purpose of the GatewayService, run the HikeService, explore its graph, and 
make a note of its limitations as a service.

## Running the Service
1. Run `make bootstrap` to run the service using Docker
1. This command will use docker compose to run the gateway and all the domain services in a single docker 
network. Once running, each service can be accessed at the following URLs:
    * Gateway Service: http://localhost:4000/graphql/
    * User Service: http://localhost:5000/graphql/
    * Park Service: http://localhost:5001/graphql/
    * Hike Service: http://localhost:5002/graphql/

### Making a GraphQL Request
1. In your browser, navigate to https://studio.apollographql.com/sandbox/explorer
1. In the top left corner you should see a Connection Settings box with a URL inside.
This should default to `http://localhost:4000/` but update it if it's set to any other value
1. In the Operation pane, paste in the following GQL query:
    ```gql
    query {
      hikes {
        id
        trail {
          id
          name
          park {
            name
          }
        }
        user {
          id
          name
        }
      }
    }
    ```
1. Hit the 'Run' button to execute your GraphQL request

Alternatively, you can make a POST request to the /graphql endpoint using your API Client of choice. For more info on
structuring a GraphQL request, see [Make an HTTP call with GraphQL](
https://learning.postman.com/docs/sending-requests/graphql/graphql-http/).

## Significance and Purpose
In the HikeService, a client can only query a hike's related user id and related trail id:

![A request to the HikeService](/assets/hike-service-graph.png)

To retrieve necessary details about the user or the trail related to the hike, a developer would need to
1. Integrate with each domain service
2. Chain requests to first retrieve the hike from the Hike Service, then the user from the User Service, and then the Trail from the Park Service. They would then need to stitch these three objects together on the client side.

Alternatively, via the GatewayService, the necessary information can be retrieved in a single request from the client:
![A request to the GatewayService](/assets/gateway-service-graph.png)

Additionally, using Apollo's federation model, all services remain loosely coupled. The domain services manage their own schemas and foreign entity relationships. Changes in the domain services are automatically represented in the gateway service via tooling like [Apollo Studio](https://www.apollographql.com/docs/federation/v1/quickstart-pt-2). 
(Although, as a proof of concept, the supergraph in this project is manually created using [these steps](https://www.apollographql.com/docs/federation/v1/quickstart)).

## Docs
The following documentation may be helpful when reviewing and understanding key components of this service:
- [ASP.NET Core in a container](https://code.visualstudio.com/docs/containers/quickstart-aspnet-core)
- [Introduction to GraphQL](https://graphql.org/learn/)
- [Apollo | Federation - Quickstart](https://www.apollographql.com/docs/federation/v1/quickstart)