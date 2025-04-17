# Twitch-Term

https://github.com/user-attachments/assets/08d833ce-1439-4e36-ad53-493d29ce4117

## Main Notes:
  
- You can set a `default quality` to be used for all streams and VODs and you can set a `specific` quality to be used by a streamer, overriding that.
  - If the set quality is not available, it will downgrade to the closest lower match (in set order) or default to `best` as a further fallback.

- In both the Streams & VODs sections, you can manually enter a streamer not on your list to fetch and watch their stream or VODs. In Vods, you can also start from a specified timestamp.

- By default, [YT-X](https://github.com/Benexl/yt-x) is added to the menu. You can keep it, remove it, or add more of your terminal apps/scripts commands to the `main menu` within the code.

- By default, the player args are for MPV, and it is the default player. If you wish to use something else, make sure to change the args in the config and the player.

**Go through the config to see all options.**

---

## Installation - General Linux

1. Get `twt-v` & `twt-v-configs` and place them in a user path. My path:
   ```
   /home/k/Documents/Apps
   ```

2. Open `twt-v` with a text editor and change the paths of the following to yours:
   ```
   STREAMERS_LIST="/home/k/Documents/Apps/twt-v-configs/streamers-list"
   CONFIG_FILE="/home/k/Documents/Apps/twt-v-configs/config"
   ```

3. Save & exit.

4. Open terminal and make `twt-v` executable:
   - `sudo chmod +x /home/k/Documents/Apps/twt-v`

4.1 Add the location to shell if it isn't already:
    - `nano ~/.bashrc` (or ~/.zshrc, etc.) and add:
   ```
   export PATH="$PATH:/home/k/Documents/Apps"
   ```

4.2 Reload the shell:
     - `source ~/.bashrc` 

### Get Twitch Client ID and Access Token

1. **Activate 2-factor authentication (2FA) for your Twitch account to proceed. (REQUIRED)**

2. Afterwards, go to: [Twitch Developer Console](https://dev.twitch.tv/console/apps/create)
   - Navigate to the `Applications` tab and click `Register your application`.
   - Fill out as you like and/or use the below as a guide:
     ```
     Name: (Any unique name)
     OAuth Redirect URLs: https://localhost/
     Category: (Pick one)
     Client Type: Public
     ```

3. Open `Dashboard`, scroll down, and click `Manage` on what you just created.

4. In the address bar, enter the following link **AND** replace `CLIENTIDHERE` with your created client ID:
   ```
   https://id.twitch.tv/oauth2/authorize?client_id=CLIENTIDHERE&redirect_uri=https://localhost/&response_type=token
   ```

5. You will be redirected to `https://localhost` (or whatever you set it to), and the **token will appear in the URL address as `access_token=`**. Nothing is meant to load.
   - Copy this token somewhere. Everything after `access_token=` but stop once you reach `&scope=`
   - *THIS TOKEN IS STRICTLY PRIVATE. DO NOT SHARE IT WITH ANYONE!*

6. Open `twt-v-configs` & open `config` file with editor.
   - At the very top, you'll see `client_id` and `access_token`.
   - Enter your `client-id` and the `access token` you just got into the respective fields.

7. The script is now fully usable. Check depends and type `twt-v` in the terminal.

---

## Dependencies

- [Fzf](https://github.com/junegunn/fzf)
- [Streamlink](https://streamlink.github.io/install.html)
- [jq](https://github.com/jqlang/jq), [curl](https://curl.se/), [sed](https://www.gnu.org/software/sed/), [awk](https://www.gnu.org/software/gawk/)

### Recommended Software

- [MPV](https://mpv.io/) (Default & Recommended) - You can use others, but update the config accordingly.
- [Kitty](https://sw.kovidgoyal.net/kitty/) (Recommended Terminal)
- [Nerd Font](https://www.nerdfonts.com/) (If icons are not working)
- [Twitch-tui](https://github.com/Xithrius/twitch-tui) - Live Stream chat with login and chat function on terminal
