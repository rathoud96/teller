defmodule Teller.Encryption do
  @block_size Application.get_env(:teller, __MODULE__)[:block_size]

  @secret_key Application.get_env(:teller, __MODULE__)[:secret_key]

  def encrypt(plaintext) do
    # create random Initialisation Vector
    iv = :crypto.strong_rand_bytes(16)
    plaintext = pad(plaintext, @block_size)

    encrypted_text =
      :crypto.crypto_one_time(:aes_128_cbc, Base.decode32!(@secret_key), iv, plaintext, true)

    encrypted_text = iv <> encrypted_text
    :base64.encode(encrypted_text)
  end

  def decrypt(ciphertext) do
    ciphertext = :base64.decode(ciphertext)
    <<iv::binary-16, ciphertext::binary>> = ciphertext

    decrypted_text =
      :crypto.crypto_one_time(:aes_128_cbc, Base.decode32!(@secret_key), iv, ciphertext, false)

    unpad(decrypted_text)
  end

  def unpad(data) do
    to_remove = :binary.last(data)
    :binary.part(data, 0, byte_size(data) - to_remove)
  end

  # PKCS5Padding
  def pad(data, block_size) do
    to_add = block_size - rem(byte_size(data), block_size)
    data <> :binary.copy(<<to_add>>, to_add)
  end
end
