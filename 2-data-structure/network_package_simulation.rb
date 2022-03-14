def buffer_add(arrived, proc_time, idx)
  @buffer[idx] = [arrived: arrived, proc_time: proc_time]
  @buffer_count[idx] = arrived + proc_time unless proc_time == 0
end

def buffer_clear(pack_arrived)
  @buffer_count.each {|k, v| @buffer_count.delete(k) if v <= pack_arrived}
end

def drop_pack(idx)
  @dropped[idx] = [dropped: -1]
end

def process_buffer
  idx = @buffer.keys.first
  current_pack = @buffer.values.first[0]
  @buffer.delete(idx)

  last_pack = @processed.values.last[0]

  start_time = current_pack[:arrived] > last_pack[:finished] ? current_pack[:arrived] : last_pack[:finished]
  finish_time = start_time + current_pack[:proc_time]

  @processed[idx] = [started: start_time,
                     arrived: current_pack[:arrived],
                     proc_time: current_pack[:proc_time],
                     finished: finish_time
                   ]

  @buffer_count[idx] = finish_time
end

def process_result
  @result = []
  result = Hash.new
  result = @processed.merge(@dropped)
  result.delete(-1)

  for idx in 0...result.length do
    r = result[idx][0]
    @result << (r[:started] || r[:dropped])
  end
end

def network_package_simulation(buffer, npacks, packs)
  return if npacks == 0

  @buffer = Hash.new
  @buffer_count = Hash.new
  @dropped = Hash.new
  @processed = Hash.new
  @processed[-1] = [started: 0, arrived:0, proc_time: 0, finished: 0, dropped: -2]

  @result = []

  packs.each_with_index do |p, idx|
    pack_arrived = p[0]
    pack_pt = p[1]

    buffer_clear(pack_arrived)
    buffer_used = @buffer_count.length

    if buffer_used < buffer
      buffer_add(pack_arrived, pack_pt, idx)
    else
      drop_pack(idx)
    end

    process_buffer if @buffer.length > 0
  end

  process_result
  @result
end



#main
input = gets.chomp.split(' ')
buffer, npacks = input.map(&:to_i)

packs = []
npacks.times do
  input = gets.chomp.split(' ')
  packs << input.map(&:to_i)
end


puts network_package_simulation(buffer, npacks, packs)
