# Cajón desastre: https://github.com/aitorvv96/cajon_desastre
# Aitor Vázquez Veloso: https://www.linkedin.com/in/aitorvazquezveloso

from pytube import YouTube, Playlist

def Download(link):
    youtubeObject = YouTube(link)
    youtubeObject = youtubeObject.streams.get_highest_resolution()
    try:
        youtubeObject.download()
    except:
        print("An error has occurred")
    print("Video download is completed successfully")

#p = Playlist('https://www.youtube.com/playlist?list=PLsdzTKpJZZa7CXdfogk67aCDHZswsXm8g')
link = input("Enter the YouTube playlist URL: ")
p = Playlist(link)

for url in p.video_urls:
  Download(url)

print('Your playlist was downloaded.')
