# speed-analysis

To automatically generate data set a cronjob like this:
```{bash}
4-59/15 * * * * /path/to/dotfiles/scripts/speedtest_data.sh -f csv -o "$HOME/data/$(date -I -u)-speeddata" 2>>$HOME/logs/speed_err.log
```
This command will run every 15 minutes (it starts from minute 4 because of a bug on linux, see [this link](https://askubuntu.com/questions/1322451/speedtest-cli-does-not-execute-when-scheduled-cron)), the output will be saved in csv format to a file named $(current-date)-speeddata.csv, and errors will be saved in a log folder.

Remember that you need to have speedtest-cli installed and linked to your path, so you may need to add the following line to your `.zshrc` or `.bashrc`:
```{bash}
export PATH="$PATH:/home/pi/.local/bin/"
```
