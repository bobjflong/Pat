require 'ribimaybe'
require 'pat'

using Pat::Extensions

context '#pat' do
  include Ribimaybe::Maybe

  it 'should work' do
    ans = [1,2,3].pat('x:y:z') do |v|
      [v.x, v.y, v.z]
    end
    expect(ans).to eq [pure(1), pure(2), pure([3])]
  end

  it 'should allow computations to pass' do
    ans = [1,2,3].pat('x:y:_') do |v|
      Just do |x,y|
        x + y
      end.run(v.x, v.y)
    end
    expect(ans).to eq Just(3)
  end

  it 'should allow computations to fail' do
    ans = [1].pat('x:y:_') do |v|
      Just do |x,y|
        x + y
      end.run(v.x, v.y)
    end
    expect(ans).to eq Nothing
  end

  context 'whole list matchers' do
    it 'should work' do
      ans = [1,2,3].pat('x@y:z') do |v|
        [v.x,v.y,v.z]
      end
      expect(ans).to eq [pure([1,2,3]), pure(1), pure([2,3])]
    end
  end

  context 'faily things' do
    it 'should treat empty slices as Nothing' do
      ans = [1,2].pat('x:y:z') do |v|
        Just do |z|
          z.size
        end.run(v.z)
      end
      expect(ans).to eq Nothing
    end
  end

  context 'duplicates' do
    it 'prevents duplicate var names in patters' do
      expect do
        [1,2].pat('x:x') { |v| v }
      end.to raise_error(Pat::Grammar::NonUniqueVariables)
    end
  end

  context 'underscores' do
    it 'should be treated as a don\'t care' do

    end
  end
end
