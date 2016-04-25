require 'image';
require 'math';
require 'itorch';


imPath = 'dataset/FDDB/pics/'

annoPath = 'dataset/FDDB/annotations/FDDB-fold-10-ellipseList.txt'
annoFile = io.input(annoPath)

-- save the name of each face to a file
faceFile = io.open('dataset/FDDB/faces/faces.txt', 'a')
io.output(faceFile)

while true do
    -- keep reading the file

    fileName = annoFile:read('*l')
    -- fileName

    if fileName == nil then break end

    -- grab the image name
    index = string.find(fileName, "/[^/]*$")
    imName = string.sub(fileName, index+1)
    -- print('processing...'..imName)
    -- imName

    -- load image
    im = image.load(imPath..fileName..'.jpg')
    -- itorch.image(im)
    -- #im

    C, H, W = im:size(1), im:size(2), im:size(3)

    -- C,H,W

    faceNum = tonumber(annoFile:read('*l'))
    -- faceNum

    -- Grab all faces
    -- faces = {}
    for faceIdx = 1, faceNum do
        line = annoFile:read('*l')

        ellipse = {}
        for token in string.gmatch(line, "[^%s]+") do
            ellipse[#ellipse+1] = tonumber(token)
        end

        r1, r2, angle, cx, cy, _ = unpack(ellipse)

        -- r1, r2, angle, cx, cy

        rectH = 2*r1*(math.cos(math.rad(math.abs(angle))))
        rectW = 2*r2*(math.cos(math.rad(math.abs(angle))))

        lx = math.max(1, cx - rectW/2)
        ly = math.max(1, cy - rectH/2)
        rx = math.min(W, cx + rectW/2)
        ry = math.min(H, cy + rectH/2)

        facePatch = im[{{},{ly,ry},{lx,rx}}]
        -- itorch.image(facePatch)

        -- save the face patch
        io.write(imName..'_'..faceIdx..'\n')
        image.save('dataset/FDDB/faces/'..imName..'_'.. faceIdx ..'.jpg', facePatch)

        -- faces[#faces+1] = image.scale(facePatch,64,64)
    end
    -- itorch.image(faces)
end

io.close(faceFile)
