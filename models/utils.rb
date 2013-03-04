# encoding: utf-8

# monkeypatches

class Hash
  def strip_all
    hash = {}
    self.each do |key, val|
      hash[key] = if val.is_a? String
        val.strip
      else
        val
      end
    end
    hash
  end
end

class String
  def urlify
    self.gsub(/à|À/, 'a').gsub(/è|é|È|É/, 'e').gsub(/ì|Ì/, 'i').gsub(/ò|Ò|Ó/, 'o').gsub(/ù|Ù/, 'u').gsub(/\W+/, '_').gsub(/_$/, '').gsub(/^_/, '').downcase
  end

  def truncate(chars=37)
    if self.length > chars
      "#{self[0..chars]}..."
    else
      self
    end
  end
end