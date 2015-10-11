defmodule Flex.Parser.Flac do
  @moduledoc """
  Parse a .flac file.
  """

  def parse(<<"fLaC",
            min_block_size_samples::size(16),
            max_block_size_samples::size(16),
            min_frame_size_bytes::size(24),
            max_frame_size_bytes::size(24),
            sample_rate_hz::size(20),
            num_channels_plus_one::size(3),
            bits_per_sample_plus_one::size(5),
            total_samples_in_stream::size(36),
            md5_signature::size(128),
            metadata_and_audio::binary>>) do
    IO.puts "got a flac!"
    extract(metadata_and_audio)
    # {metadata_blocks, audio_frames} = extract(metadata_and_audio)
  end

  defp extract(<<0,
               block_type::size(7),
               metadata_length::size(24),
               metadata_block::size(metadata_length), # mind blown
               remainder::binary>>) do
    IO.puts "here comes some metadata"
    extract_metadata({block_type, metadata_block}, remainder)
  end
  defp extract(<<1,
               block_type::size(7),
               metadata_length::size(24),
               metadata_block::size(metadata_length), # mind blown
               remainder::binary>>) do
    IO.puts "this is the flac's last block of metadata"
    extract_last_metadata({block_type, metadata_block}, remainder)
  end

  defp extract_metadata({_block_type, _metadata_block}, remainder) do
    extract(remainder)
  end

  defp extract_last_metadata({_block_type, _metadata_block}, remainder) do
    IO.puts "down to the audio frames!"
    remainder
  end
end
