# Cajón desastre: https://github.com/aitorvv96/cajon_desastre
# Aitor Vázquez Veloso: https://www.linkedin.com/in/aitorvazquezveloso

from pytube import YouTube

def Download(link):
    youtubeObject = YouTube(link)
    youtubeObject = youtubeObject.streams.get_highest_resolution()
    try:
        youtubeObject.download()
    except:
        print("An error has occurred")
    print("Download is completed successfully")


link = input("Enter the YouTube video URL: ")
Download(link)
