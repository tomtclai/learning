# Instructions to upload server component

### Setup
1. Install homebrew on your Mac from [here](https://brew.sh/) if you haven't already.
2. Create a free Heroku account [here](https://www.heroku.com/)
3. Install Heroku command line tools `brew install heroku`
4. Login to Heroku from the command line: `heroku login`
5. Run the following commands to install vapor
   - brew tap vapor/homebrew-tap
   - brew update
   - brew install vapor

### Setup iOS Project
1. Open iOS project
2. Change bundle identifier to something unique (com.razeware.AppManager is taken 😀)

### Setup Server
1. Find your Apple Developer Team Identifier. Go to developer.apple.com > Account > Membership, and locate Team ID.
2. Open AppManager-server Xcode project
3. Open **Public/.well-known/apple-app-site-association**.
4. Replace the text in the placeholders with your team identifier, and the iOS bundle identifier from above. 

### Deploy Server
1. Set up your server directory as a Git repository. In Terminal, `cd` to your project directory and type:
	- `git init`
	- `git add .`
	- `git commit -m "Initial Commit"`
1. In the server directory, in terminal, run `vapor heroku init`. When prompted, select yes to a custom name, and then provide your own name (all lowercase, no special characters). You can leave all other questions as  no, except the final "Would you like to push to heroku now?" which should be yes.
2. Verify website works <*the custom name your provided in previous step*>.herokuapp.com
3. Back in the iOS project, change the Associated Domains web credentials to your new heroku website url from the previous step.


### Finally
1. Navigate to website on iOS Device, enter any 5 character username/5 character password
2. Press Login, and make sure to save password when prompted. Note that there is no actual authentication going on, this is just to prompt your device to save a username/password for this domain.
3. Run iOS app from project on same device. 
4. When entering username/password, you should be shown the username for the website in the QuickType bar. 
