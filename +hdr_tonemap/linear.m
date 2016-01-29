function ldr = linear(hdr)
    bottom = min(min(min(hdr)));
    top = max(max(max(hdr)));
    
    ldr = (hdr - bottom)./top;
end