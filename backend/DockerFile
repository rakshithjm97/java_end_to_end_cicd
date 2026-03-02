from node:21 AS backednd-builder 

#set up working directory

WORKDIR /app

#code

COPY . .

# install package

RUN npm i

#tests

RUN npm run test


#stage2

FROM node:21-slim

#setup working dir

WORKDIR /app

#copying from above stage
copy --from=backednd-builder /app .
copy .env.docker  .env


#port
EXPOSE 8000

#app
CMD [ "npm", "start" ]










