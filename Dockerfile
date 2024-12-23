# Use a Node.js base image
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy only the files needed for installation first (layer caching)
COPY package.json yarn.lock .yarnrc.yml .pnp.cjs .pnp.loader.mjs ./
COPY .yarn/ .yarn/

# Install dependencies using Yarn in Plug'n'Play mode
RUN yarn install --immutable

# Copy the rest of the application files
COPY index.js ./index.js
COPY supergraph.graphql ./supergraph.graphql

# Expose the application port (replace 3000 with your app's port if different)
EXPOSE 4000

# Set the command to start the application
CMD ["yarn", "start"]