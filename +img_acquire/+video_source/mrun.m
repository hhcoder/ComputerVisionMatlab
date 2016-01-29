imaqhwinfo

dev_hw = imaqhwinfo('winvideo');
dev_info = dev_hw.DeviceInfo;
dev_support = dev_info.SupportedFormats;
%%
vid = videoinput('winvideo', 1,'RGB24_640x480');

aviobj= avifile('.\test5.avi');

set( vid, 'LoggingMode', 'disk&memory' );
set( vid, 'DiskLogger', aviobj );
%set( vid, 'TriggerRepeat', 2 );

%triggerconfig(vid, 'manual');

start(vid);

trigger(vid);
%%

stop(vid);
delete(vid);