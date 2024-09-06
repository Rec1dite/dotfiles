# See [https://github.com/iberianpig/fusuma/blob/main/README.md]

# TODO: See [https://github.com/iberianpig/fusuma-plugin-tap]
{
  threshold = {
    swipe = 0.1;
  };
  interval = {
    swipe = 0.7;
  };
  swipe = {
    "3" = {
      # Next song
      right = { command = "playerctl next"; };
      # Previous song
      left = { command = "playerctl previous"; };
      # Play/pause
      down = { command = "playerctl play-pause"; };
    };
    "4" = {
      # Fast forward
      right = { command = "playerctl position 1.5+"; };
      # Rewind
      left = { command = "playerctl position 1.5-"; };
    };
  };
}