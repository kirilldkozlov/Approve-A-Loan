require 'decisiontree'
require 'zlib'

class Analyzer
  ATTRIBUTES = [
    'Existing chequing balance',
    'Loan duration in months',
    'Credit history status',
    'Purpose for loan',
    'Loan amount',
    'Value of savings',
    'Present employment length',
    'Relationship status and sex',
    'Other debtors/guarantors',
    'Property status',
    'Age in years',
    'Other loans',
    'Housing status',
    'Job status',
    'Foreign worker status'
  ].freeze

  def predict(testing_array)
    tree.predict(testing_array)
  end

  def sync
    if File.file?("#{Rails.root}/lib/data/german_credit.decision_tree")
      data_modified = File.mtime("#{Rails.root}/lib/data/german.data")
      tree_modified = File.mtime(
        "#{Rails.root}/lib/data/german_credit.decision_tree"
      )

      if data_modified > tree_modified ||
         File.zero?("#{Rails.root}/lib/data/german_credit.decision_tree")
        construct_tree
      end
    else
      construct_tree
    end
  end

  def test(test_standard)
    data = formatted_data
    training_range = ((data.length * 80) / 100.to_f).ceil
    test_range = data.length - training_range
    training = data.first(training_range)
    test = data.last(test_range)

    dec_tree = DecisionTree::Bagging.new(ATTRIBUTES, training, 2, :continuous)
    dec_tree.train

    correct = 0

    test.each do |t|
      predict = dec_tree.predict(t)

      correct += 1 if predict.first == t.last
    end

    (correct.to_f / test.length.to_f) > test_standard
  end

  private

  def tree
    marshalled_tree = File.read(
      "#{Rails.root}/lib/data/german_credit.decision_tree"
    )

    marshalled_tree = Zlib::Inflate.inflate(marshalled_tree)
    Marshal.load(marshalled_tree)
  end

  def construct_tree
    data = formatted_data

    dec_tree = DecisionTree::Bagging.new(ATTRIBUTES, data, 2, :continuous)
    dec_tree.train

    save_tree(dec_tree)
  end

  def save_tree(dec_tree)
    marshalled_tree = Marshal.dump(dec_tree)
    marshalled_tree = Zlib::Deflate.deflate(marshalled_tree)

    File.open("#{Rails.root}/lib/data/german_credit.decision_tree", 'wb') do |f|
      f.write(marshalled_tree)
    end
  end

  def formatted_data
    data = File.readlines("#{Rails.root}/lib/data/german.data").map do |line|
      line.split.map do |item|
        new_value = if item == 'A410'
                      10
                    else
                      item[0] == 'A' ? item[-1, 1] : item
                    end

        new_value.to_f
      end
    end

    data.shuffle
  end
end
