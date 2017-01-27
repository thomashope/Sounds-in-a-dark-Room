Audio = {}

function Audio.load( folder, list )
	local result = {}
	for i = 1, #list do
		table.insert( result, folder..'/'..list[i] )
	end

	return result
end