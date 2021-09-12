# specify the node base image with your desired version node:<version>
FROM node:14

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH
# install app dependencies
COPY package.json ./
RUN npm install

# add app
COPY . ./

EXPOSE 2999

# start app
CMD ["npm", "start"]
